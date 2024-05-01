const express = require('express');
const router = express.Router();
const db = require('./config/db');

// POST endpoint to add a new meal plan
router.post('/', async (req, res) => {
    const { userId, date, type, recipes } = req.body; // Assume 'recipes' is an array of recipeIds
    const connection = await db.promise().getConnection();
    try {
        await connection.beginTransaction();

        // Insert into MealPlans table
        const mealPlanQuery = `INSERT INTO mealplans (userId, date, type) VALUES (?, ?, ?)`;
        const [mealPlanResult] = await connection.query(mealPlanQuery, [userId, date, type]);
        const mealPlanId = mealPlanResult.insertId;

        // Calculate total nutrition from recipes
        let totalCalories = 0, totalProteins = 0, totalCarbs = 0, totalFats = 0;
        for (let recipeId of recipes) {
            const nutritionQuery = `SELECT calories, proteins, carbs, fats FROM recipenutrition WHERE recipeId = ?`;
            const [nutrition] = await connection.query(nutritionQuery, [recipeId]);
            totalCalories += nutrition[0].calories;
            totalProteins += nutrition[0].proteins;
            totalCarbs += nutrition[0].carbs;
            totalFats += nutrition[0].fats;
        }

        // Insert into MealNutrition table
        const nutritionInsertQuery = `INSERT INTO mealnutrition (mealplanid, calories, proteins, carbs, fats) VALUES (?, ?, ?, ?, ?)`;
        await connection.query(nutritionInsertQuery, [mealPlanId, totalCalories, totalProteins, totalCarbs, totalFats]);

        await connection.commit();
        res.status(201).send({ message: 'Meal plan and nutrition added successfully', mealPlanId });
    } catch (error) {
        await connection.rollback();
        res.status(500).send({ message: 'Failed to add meal plan and nutrition', error: error.toString() });
    } finally {
        connection.release();
    }
});

// GET endpoint to fetch meal plans by userId
router.get('/:userId', (req, res) => {
    const { userId } = req.params;
    const query = `SELECT * FROM mealplans WHERE userId = ?`;
    db.query(query, [userId], (err, results) => {
        if (err) {
            return res.status(500).send({ message: 'Failed to fetch meal plans', error: err.toString() });
        }
        res.status(200).json(results);
    });
});

// PUT endpoint to update a meal plan
router.put('/:id', (req, res) => {
    const { userId, date, type } = req.body;
    const { id } = req.params;
    const query = `UPDATE mealplans SET userId = ?, date = ?, type = ? WHERE id = ?`;
    db.query(query, [userId, date, type, id], (err, results) => {
        if (err) {
            return res.status(500).send({ message: 'Failed to update meal plan', error: err.toString() });
        }
        res.status(200).send({ message: 'Meal plan updated successfully' });
    });
});

// DELETE endpoint to delete a meal plan
router.delete('/:id', (req, res) => {
    const { id } = req.params;
    const query = `DELETE FROM mealplans WHERE id = ?`;
    db.query(query, [id], (err, results) => {
        if (err) {
            return res.status(500).send({ message: 'Failed to delete meal plan', error: err.toString() });
        }
        res.status(200).send({ message: 'Meal plan deleted successfully' });
    });
});

module.exports = router;
