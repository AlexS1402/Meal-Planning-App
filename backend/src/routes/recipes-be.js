const express = require("express");
const router = express.Router();
const { redisClient, clearCache } = require("../config/redis-client.js");
const db = require("../config/db.js"); // Import the centralized db instance
const axios = require("axios");
const fs = require("fs").promises;
require('dotenv').config();


// Open API Key and Engine IRL
const OPENAI_URL =
  "https://api.openai.com/v1/engines/davinci-codex/completions";

const OpenAI = require("openai");
console.log("Using OpenAI API Key:", process.env.OPENAI_API_KEY);
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY});

// POST route to add a new recipe
router.post("/", async (req, res) => {
  const { userId, title, description, calories, proteins, carbs, fats } =
    req.body;

  try {
    await db.promise().beginTransaction();
    const queryRecipes = `INSERT INTO Recipes (userId, title, description) VALUES (?, ?, ?)`;
    const recipeResults = await db
      .promise()
      .query(queryRecipes, [userId, title, description]);
    const recipeId = recipeResults[0].insertId;

    const queryNutrition = `INSERT INTO RecipeNutrition (recipeId, calories, proteins, carbs, fats) VALUES (?, ?, ?, ?, ?)`;
    await db
      .promise()
      .query(queryNutrition, [recipeId, calories, proteins, carbs, fats]);

    await db.promise().commit();
    clearCache();
    res
      .status(201)
      .send({ message: "Recipe added successfully", recipeId: recipeId });
  } catch (error) {
    await db.promise().rollback();
    res
      .status(500)
      .send({ message: "Failed to handle request", error: error.toString() });
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
    res
      .status(500)
      .send({ message: "Failed to delete recipe", error: error.toString() });
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

// Route to get recipe suggestions from OpenAI
router.post("/suggestions", async (req, res) => {
  const ingredients = req.body.ingredients; // User-provided ingredients list
  if (!ingredients || !ingredients.length) {
    return res.status(400).send({ message: "Ingredients list is required" });
  }

  try {
    const recipes = await fetchRecipeSuggestions(ingredients);
    res.json({ recipes });
  } catch (error) {
    console.error("Error fetching recipe suggestions:", error);
    res.status(500).send({
      message: "Failed to fetch recipe suggestions",
      error: error.toString(),
    });
  }
});

// Function to fetch recipe suggestions from OpenAI
async function fetchRecipeSuggestions(ingredients) {
  const prompt = `Generate five recipes based on these ingredients: ${ingredients.join(
    ", "
  )} with their nutritional information including calories, carbs, proteins, and fats.`;
  try {
    var response = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "user",
          content: prompt,
        },
      ],
    });

    return response.choices[0].message.content;

    // const response = await axios.post(
    //   "https://api.openai.com/v1/engines/davinci-codex/completions",
    //   {
    //     prompt: prompt,
    //     max_tokens: 150,
    //     temperature: 0.7,
    //   },
    //   {
    //     headers: {
    //       Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
    //       "Content-Type": "application/json",
    //     },
    //   }
    // );
    // return response.data.choices[0].text;
  } catch (error) {
    console.error(
      "Error calling OpenAI:",
      error.response ? error.response.data : error.message
    );
    throw new Error("Failed to fetch recipe suggestions from OpenAI");
  }
}

// Route to handle POST request for recipe suggestions
router.post("/suggest-recipes", async (req, res) => {
  const ingredients = req.body.ingredients; // Expecting ingredients as an array of strings
  try {
    const recipes = await fetchRecipeSuggestions(ingredients);
    res.json({ recipes: recipes });
  } catch (error) {
    res.status(500).send({
      message: "Failed to fetch recipe suggestions",
      error: error.toString(),
    });
  }
});

module.exports = router;
