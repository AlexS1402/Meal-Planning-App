const express = require("express");
const router = express.Router();
const { redisClient, clearCache } = require('../config/redis-client.js');
const db = require("../config/db.js"); // Import the centralized db instance

// POST route to add a new recipe
router.post("/", async (req, res) => {
    const { userId, title, description, calories, proteins, carbs, fats } = req.body;
    
    try {
      await db.promise().beginTransaction();
      const queryRecipes = `INSERT INTO Recipes (userId, title, description) VALUES (?, ?, ?)`;
      const recipeResults = await db.promise().query(queryRecipes, [userId, title, description]);
      const recipeId = recipeResults[0].insertId;
  
      const queryNutrition = `INSERT INTO RecipeNutrition (recipeId, calories, proteins, carbs, fats) VALUES (?, ?, ?, ?, ?)`;
      await db.promise().query(queryNutrition, [recipeId, calories, proteins, carbs, fats]);
  
      await db.promise().commit();
      clearCache();
      res.status(201).send({ message: "Recipe added successfully", recipeId: recipeId });
    } catch (error) {
      await db.promise().rollback();
      res.status(500).send({ message: "Failed to handle request", error: error.toString() });
    }
  });  
  
// DELETE route to delete a recipe
router.delete("/:id", async (req, res) => {
    const { id } = req.params;
  
    try {
      await db.promise().beginTransaction();
      const queryRecipes = `DELETE FROM Recipes WHERE id = ?`;
      await db.promise().query(queryRecipes, [id]);
      await db.promise().commit();
      clearCache();
      res.status(200).send({ message: "Recipe deleted successfully" });
    } catch (error) {
      await db.promise().rollback();
      res.status(500).send({ message: "Failed to delete recipe", error: error.toString() });
    }
  });  

// UPDATE route to update a recipe and its nutrition
router.put("/:id", (req, res) => {
  const { id } = req.params;
  const { userId, title, description, calories, proteins, carbs, fats } =
    req.body;

  // Start a transaction
  db.beginTransaction((err) => {
    if (err) {
      console.error("Transaction Start Error:", err);
      return res.status(500).send({
        message: "Failed to start transaction",
        error: err.toString(),
      });
    }

    // Update Recipes table
    const queryRecipes = `UPDATE Recipes SET userId = ?, title = ?, description = ? WHERE id = ?`;
    db.query(queryRecipes, [userId, title, description, id], (err, results) => {
      if (err) {
        console.error("Failed to update recipe:", err);
        return db.rollback(() => {
          res.status(500).send({
            message: "Failed to update recipe",
            error: err.toString(),
          });
        });
      }

      // Update RecipeNutrition table
      const queryNutrition = `UPDATE RecipeNutrition SET calories = ?, proteins = ?, carbs = ?, fats = ? WHERE recipeId = ?`;
      db.query(
        queryNutrition,
        [calories, proteins, carbs, fats, id],
        (err, results) => {
          if (err) {
            console.error("Failed to update recipe nutrition:", err);
            return db.rollback(() => {
              res.status(500).send({
                message: "Failed to update recipe nutrition",
                error: err.toString(),
              });
            });
          }

          // Commit transaction
          db.commit((err) => {
            if (err) {
              console.error("Transaction Commit Error:", err);
              return db.rollback(() => {
                res.status(500).send({
                  message: "Failed to commit transaction",
                  error: err.toString(),
                });
              });
            }
            clearCache();
            res.status(200).send({ message: "Recipe updated successfully" });
          });
        }
      );
    });
  });
});

// GET route to fetch recipes by userId, with pagination and search
router.get("/", async (req, res) => {
  const { userId, search, page = 1, pageSize = 10 } = req.query;
  const limit = parseInt(pageSize, 10);
  const offset = (page - 1) * limit;
  const cacheKey = `recipes:${userId}:${search || "all"}:page:${page}`;

  try {
    const cachedData = await redisClient.get(cacheKey);
    if (cachedData) {
      console.log("Fetching from cache");
      res.json(JSON.parse(cachedData));
    } else {
      let query =
        "SELECT r.id, r.title, r.description, rn.calories, rn.proteins, rn.carbs, rn.fats FROM Recipes r JOIN RecipeNutrition rn ON r.id = rn.recipeId WHERE r.userId = ?";
      let queryParams = [userId];

      if (search) {
        query += " AND (r.title LIKE ? OR r.description LIKE ?)";
        queryParams.push(`%${search}%`, `%${search}%`);
      }

      query += " LIMIT ? OFFSET ?";
      queryParams.push(limit, offset);

      const [results] = await db.promise().query(query, queryParams);
      redisClient.setEx(cacheKey, 3600, JSON.stringify(results));
      res.json(results);
    }
  } catch (error) {
    console.error("Failed during Redis operation", error);
    res.status(500).send("Server error");
  }
});

module.exports = router;