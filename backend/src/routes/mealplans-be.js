const express = require("express");
const router = express.Router();
const db = require("../config/db.js");

//add mealPlans to database
router.post('/', (req, res) => {
  const { userId, name, date, type, recipes } = req.body; // Include title from the request

  // Start a transaction
  db.beginTransaction(err => {
      if (err) {
          console.error('Transaction Start Error:', err);
          return res.status(500).send({ message: 'Failed to start transaction', error: err.toString() });
      }

      // Insert into MealPlans table
      const queryMealPlans = `INSERT INTO MealPlans (userId, name, date, type) VALUES (?, ?, ?, ?)`;
      db.query(queryMealPlans, [userId, name, date, type], (err, results) => {
          if (err) {
              console.error('Failed to add meal plan:', err);
              return db.rollback(() => {
                  res.status(500).send({ message: 'Failed to add meal plan', error: err.toString() });
              });
          }

          const mealPlanId = results.insertId;

          // Calculate total nutrition from recipes and insert into MealNutrition table
          let totalCalories = 0, totalProteins = 0, totalCarbs = 0, totalFats = 0;
          for (let recipeId of recipes) {
              const queryNutrition = `SELECT calories, proteins, carbs, fats FROM recipenutrition WHERE recipeId = ?`;
              db.query(queryNutrition, [recipeId], (err, nutrition) => {
                  if (err) {
                      console.error('Failed to add recipe nutrition:', err);
                      return db.rollback(() => {
                          res.status(500).send({ message: 'Failed to add recipe nutrition', error: err.toString() });
                      });
                  }
                  totalCalories += nutrition[0].calories;
                  totalProteins += nutrition[0].proteins;
                  totalCarbs += nutrition[0].carbs;
                  totalFats += nutrition[0].fats;

                  if (recipes.indexOf(recipeId) === recipes.length - 1) {
                      const nutritionInsertQuery = `INSERT INTO mealnutrition (mealplanid, calories, proteins, carbs, fats) VALUES (?, ?, ?, ?, ?)`;
                      db.query(nutritionInsertQuery, [mealPlanId, totalCalories, totalProteins, totalCarbs, totalFats], (err, result) => {
                          if (err) {
                              console.error('Failed to insert nutrition data:', err);
                              return db.rollback(() => {
                                  res.status(500).send({ message: 'Failed to insert nutrition data', error: err.toString() });
                              });
                          }
                          db.commit(err => {
                              if (err) {
                                  console.error('Transaction Commit Error:', err);
                                  return db.rollback(() => {
                                      res.status(500).send({ message: 'Failed to commit transaction', error: err.toString() });
                                  });
                              }
                              res.status(201).send({ message: 'Meal plan and nutrition added successfully', mealPlanId });
                          });
                      });
                  }
              });
          }
      });
  });
});

// PUT endpoint to handle both marking the meal as consumed and inserting nutrition data
router.put("/markConsumed/:id", async (req, res) => {
  const { id } = req.params;
  const { userId, dateConsumed, calories, proteins, carbs, fats } = req.body;

  const updateMealPlanQuery = `UPDATE mealplans SET consumed = 1 WHERE id = ?`;
  const insertNutritionDataQuery = `
        INSERT INTO nutritiondata (userId, dateConsumed, calories, proteins, carbs, fats)
        VALUES (?, ?, ?, ?, ?, ?);
    `;

  // Start a transaction
  db.beginTransaction((err) => {
    if (err) {
      return res
        .status(500)
        .send({ message: "Transaction start failed", error: err.toString() });
    }

    // Update the mealplans table
    db.query(updateMealPlanQuery, [id], (err, results) => {
      if (err) {
        return db.rollback(() => {
          res
            .status(500)
            .send({
              message: "Failed to update meal plan status",
              error: err.toString(),
            });
        });
      }

    console.log('Update mealplans result:', results);

      // Insert into nutritiondata table
    try {
        const insertResults = db.query(insertNutritionDataQuery, [userId, dateConsumed, calories, proteins, carbs, fats]);
        console.log('Insert nutritiondata result:', insertResults);
    } catch (error) {
        console.error('Error during INSERT into nutritiondata:', error);
        throw error; // This will ensure the error is propagated and transaction is rolled back
    }
    
          // Commit the transaction
          db.commit((err) => {
            if (err) {
              return db.rollback(() => {
                res
                  .status(500)
                  .send({
                    message: "Transaction commit failed",
                    error: err.toString(),
                  });
              });
            }
            res
              .status(200)
              .send({ message: "Meal marked as consumed successfully" });
          });
        }
      );
    });
  });
//});

// GET endpoint to fetch meal plans by userId
router.get("/:userId", (req, res) => {
  const { userId } = req.params;
  const query = `
        SELECT mp.id, mp.userId, mp.date, mp.type, mp.name, mp.consumed, mn.calories, mn.proteins, mn.carbs, mn.fats 
        FROM mealplans mp
        LEFT JOIN mealnutrition mn ON mp.id = mn.mealplanid
        WHERE mp.userId = ? AND mp.consumed = 0;
    `;
  db.query(query, [userId], (err, results) => {
    if (err) {
      return res
        .status(500)
        .send({ message: "Failed to fetch meal plans", error: err.toString() });
    }
    res.status(200).json(results);
  });
});

// PUT endpoint to update a meal plan
router.put("/:id", (req, res) => {
  const { userId, name, date, type, calories, proteins, carbs, fats } = req.body;
  const { id } = req.params;

  db.beginTransaction(err => {
    if (err) {
      return res.status(500).send({ message: "Failed to start transaction", error: err.toString() });
    }

    const updateMealPlanQuery = "UPDATE mealplans SET userId = ?, name = ?, date = ?, type = ? WHERE id = ?";
    db.query(updateMealPlanQuery, [userId, name, date, type, id], (err, result) => {
      if (err) {
        return db.rollback(() => {
          res.status(500).send({ message: "Failed to update meal plan", error: err.toString() });
        });
      }

      const updateNutritionQuery = "UPDATE mealnutrition SET calories = ?, proteins = ?, carbs = ?, fats = ? WHERE mealplanid = ?";
      db.query(updateNutritionQuery, [calories, proteins, carbs, fats, id], (err, result) => {
        if (err) {
          return db.rollback(() => {
            res.status(500).send({ message: "Failed to update nutritional information", error: err.toString() });
          });
        }

        db.commit(err => {
          if (err) {
            return db.rollback(() => {
              res.status(500).send({ message: "Failed to commit transaction", error: err.toString() });
            });
          }
          res.status(200).send({ message: "Meal plan updated successfully" });
        });
      });
    });
  });
});

// DELETE endpoint to delete a meal plan and related nutrition information
router.delete("/:id", (req, res) => {
  const { id } = req.params;
  const deleteNutritionQuery = `DELETE FROM mealnutrition WHERE mealplanid = ?`;
  const deleteMealPlanQuery = `DELETE FROM mealplans WHERE id = ?`;

  db.beginTransaction((err) => {
    if (err) {
      return res
        .status(500)
        .send({ message: "Transaction start failed", error: err.toString() });
    }

    db.query(deleteNutritionQuery, [id], (err, results) => {
      if (err) {
        return db.rollback(() => {
          res
            .status(500)
            .send({
              message: "Failed to delete meal nutrition",
              error: err.toString(),
            });
        });
      }

      db.query(deleteMealPlanQuery, [id], (err, results) => {
        if (err) {
          return db.rollback(() => {
            res
              .status(500)
              .send({
                message: "Failed to delete meal plan",
                error: err.toString(),
              });
          });
        }

        db.commit((err) => {
          if (err) {
            return db.rollback(() => {
              res
                .status(500)
                .send({
                  message: "Transaction commit failed",
                  error: err.toString(),
                });
            });
          }
          res.status(200).send({ message: "Meal plan deleted successfully" });
        });
      });
    });
  });
});

module.exports = router;
