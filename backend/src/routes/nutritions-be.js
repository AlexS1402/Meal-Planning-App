const express = require("express");
const router = express.Router();
const db = require("../config/db.js");

// Endpoint to fetch data
router.get('/:userId/:type', async (req, res) => {
    const { userId, type } = req.params;

    try {
        const query = `SELECT dateConsumed, ${type} FROM nutritiondata WHERE userId = ? ORDER BY dateConsumed`;
        const [results] = await db.promise().query(query, [userId]);
        res.json(results);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

module.exports = router;
