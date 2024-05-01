const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const saltRounds = 10;
const db = require('../config/db');  // Adjust the path as necessary to ensure it matches your project structure

// Registration Endpoint
router.post('/register', async (req, res) => {
    const { username, password } = req.body;
    try {
        const hash = await bcrypt.hash(password, saltRounds);
        db.query('INSERT INTO Users (username, password_hash) VALUES (?, ?)', [username, hash], (err, results) => {
            if (err) {
                return res.status(500).send({ message: 'Failed to register user', error: err.toString() });
            }
            res.status(201).send({ message: 'User registered successfully' });
        });
    } catch (error) {
        res.status(500).send({ message: 'Error hashing password', error: error.toString() });
    }
});

// Login Endpoint
router.post('/login', (req, res) => {
    const { username, password } = req.body;
    // Query to find the user's hashed password based on the provided username
    db.query('SELECT password_hash FROM Users WHERE username = ?', [username], async (err, results) => {
        if (err) {
            return res.status(500).send({ message: 'Server error', error: err.toString() });
        }
        if (results.length === 0) {
            return res.status(401).send({ message: 'Authentication failed' });
        }
        // If user is found, compare the provided password with the hashed password in the database
        const match = await bcrypt.compare(password, results[0].password_hash);
        if (match) {
            res.send({ message: 'Login successful' });
        } else {
            res.status(401).send({ message: 'Authentication failed' });
        }
    });
});

module.exports = router;
