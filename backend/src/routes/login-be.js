const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const saltRounds = 10;
const db = require("../config/db"); // Adjust the path as necessary to ensure it matches your project structure

// Registration Endpoint
router.post("/register", async (req, res) => {
  const { username, password } = req.body;
  try {
    const hash = await bcrypt.hash(password, saltRounds);
    db.query(
      "INSERT INTO Users (username, password_hash) VALUES (?, ?)",
      [username, hash],
      (err, results) => {
        if (err) {
          return res
            .status(500)
            .send({
              message: "Failed to register user",
              error: err.toString(),
            });
        }
        res.status(201).send({ message: "User registered successfully" });
      }
    );
  } catch (error) {
    res
      .status(500)
      .send({ message: "Error hashing password", error: error.toString() });
  }
});

// Login Endpoint
router.post('/login', (req, res) => {
    const { username, password } = req.body;
    
    // Query to find user by username
    const query = "SELECT * FROM Users WHERE username = ?";
  db.query(query, [username], async (err, results) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).send({ message: 'Database error', error: err.toString() });
    }

    if (results.length === 0) {
      return res.status(401).send({ message: 'User not found' });
    }

    const user = results[0];

    // Compare provided password with the hashed password in the database
    const match = await bcrypt.compare(password, user.password_hash);
    if (match) {
      req.session.userId = user.id; // Set userId to session after successful login
      res.json({ message: 'Logged in successfully' });
    } else {
      res.status(401).send('Authentication failed');
    }
    });
  });

    // Logout Endpoint
  router.get('/logout', (req, res) => {
    // Clear session data or token
    req.session.destroy(err => {
      if (err) {
        return res.status(500).send({ message: "Failed to log out", error: err.toString() });
      }
      res.send({ message: "Logged out successfully" });
    });
  });
  

module.exports = router;
