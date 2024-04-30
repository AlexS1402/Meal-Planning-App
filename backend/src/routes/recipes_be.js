const express = require('express');
const router = express.Router();
const db = require('../db.js'); // Import the centralized db instance

// POST route to add a new recipe
router.post('/', (req, res) => {
    const { title, description, calories, proteins, carbs, fats } = req.body;
    // Start a transaction
    db.beginTransaction(err => {
        if (err) {
            console.error('Transaction Start Error:', err);
            return res.status(500).send({ message: 'Failed to start transaction', error: err.toString() });
        }

        // Insert into Recipes table
        const queryRecipes = `INSERT INTO Recipes (title, description) VALUES (?, ?)`;
        db.query(queryRecipes, [title, description], (err, results) => {
            if (err) {
                console.error('Failed to add recipe:', err);
                return db.rollback(() => {
                    res.status(500).send({ message: 'Failed to add recipe', error: err.toString() });
                });
            }

            const recipeId = results.insertId;

            // Insert into RecipeNutrition table
            const queryNutrition = `INSERT INTO RecipeNutrition (recipeId, calories, proteins, carbs, fats) VALUES (?, ?, ?, ?, ?)`;
            db.query(queryNutrition, [recipeId, calories, proteins, carbs, fats], (err, results) => {
                if (err) {
                    console.error('Failed to add recipe nutrition:', err);
                    return db.rollback(() => {
                        res.status(500).send({ message: 'Failed to add recipe nutrition', error: err.toString() });
                    });
                }

                // Commit transaction
                db.commit(err => {
                    if (err) {
                        console.error('Transaction Commit Error:', err);
                        return db.rollback(() => {
                            res.status(500).send({ message: 'Failed to commit transaction', error: err.toString() });
                        });
                    }
                    res.status(201).send({ message: 'Recipe added successfully', recipeId: recipeId });
                });
            });
        });
    });
});

// DELETE route to delete a recipe
router.delete('/:id', (req, res) => {
    const { id } = req.params;
    console.log(`Attempting to delete recipe with ID: ${id}`);  // Log the incoming ID

    db.beginTransaction(err => {
        if (err) {
            console.error('Transaction Start Error:', err);
            return res.status(500).send({ message: 'Failed to start transaction', error: err.toString() });
        }

        const queryRecipes = `DELETE FROM Recipes WHERE id = ?`;
        console.log(`Deleting recipe data for recipe ID: ${id}`);
        db.query(queryRecipes, [id], (err, results) => {
            if (err) {
                console.error('Failed to delete recipe:', err);
                return db.rollback(() => {
                    res.status(500).send({ message: 'Failed to delete recipe', error: err.toString() });
                });
            }

            console.log('Recipe deleted successfully');
            db.commit(err => {
                if (err) {
                    console.error('Transaction Commit Error:', err);
                    return db.rollback(() => {
                        res.status(500).send({ message: 'Failed to commit transaction', error: err.toString() });
                    });
                }
                res.status(200).send({ message: 'Recipe deleted successfully' });
            });
        });
    });
});

// UPDATE route to update a recipe and its nutrition
router.put('/:id', (req, res) => {
    const { id } = req.params;
    const { title, description, calories, proteins, carbs, fats } = req.body;

    // Start a transaction
    db.beginTransaction(err => {
        if (err) {
            console.error('Transaction Start Error:', err);
            return res.status(500).send({ message: 'Failed to start transaction', error: err.toString() });
        }

        // Update Recipes table
        const queryRecipes = `UPDATE Recipes SET title = ?, description = ? WHERE id = ?`;
        db.query(queryRecipes, [title, description, id], (err, results) => {
            if (err) {
                console.error('Failed to update recipe:', err);
                return db.rollback(() => {
                    res.status(500).send({ message: 'Failed to update recipe', error: err.toString() });
                });
            }

            // Update RecipeNutrition table
            const queryNutrition = `UPDATE RecipeNutrition SET calories = ?, proteins = ?, carbs = ?, fats = ? WHERE recipeId = ?`;
            db.query(queryNutrition, [calories, proteins, carbs, fats, id], (err, results) => {
                if (err) {
                    console.error('Failed to update recipe nutrition:', err);
                    return db.rollback(() => {
                        res.status(500).send({ message: 'Failed to update recipe nutrition', error: err.toString() });
                    });
                }

                // Commit transaction
                db.commit(err => {
                    if (err) {
                        console.error('Transaction Commit Error:', err);
                        return db.rollback(() => {
                            res.status(500).send({ message: 'Failed to commit transaction', error: err.toString() });
                        });
                    }
                    res.status(200).send({ message: 'Recipe updated successfully' });
                });
            });
        });
    });
});

// GET route to fetch all recipes and its nutrition
router.get('/', (req, res) => {
    const search = req.query.search;
    const page = parseInt(req.query.page) || 1;
    const pageSize = parseInt(req.query.pageSize) || 10; // Default page size
    const offset = (page - 1) * pageSize;

    let queryBase = 'SELECT Recipes.id, Recipes.title, Recipes.description, RecipeNutrition.calories, RecipeNutrition.proteins, RecipeNutrition.carbs, RecipeNutrition.fats FROM Recipes JOIN RecipeNutrition ON Recipes.id = RecipeNutrition.recipeId';
    let query = queryBase;

    if (search) {
        query += ' WHERE Recipes.title LIKE ? OR Recipes.description LIKE ?';
        query += ` LIMIT ${pageSize} OFFSET ${offset}`;
        const searchPattern = `%${search}%`;
        db.query(query, [searchPattern, searchPattern], (err, results) => {
            if (err) {
                console.error('Failed to fetch recipes:', err);
                res.status(500).send('Failed to fetch recipes');
                return;
            }
            res.json(results);
        });
    } else {
        query += ` LIMIT ${pageSize} OFFSET ${offset}`;
        db.query(query, (err, results) => {
            if (err) {
                console.error('Failed to fetch recipes:', err);
                res.status(500).send('Failed to fetch recipes');
                return;
            }
            res.json(results);
        });
    }
});


module.exports = router;
