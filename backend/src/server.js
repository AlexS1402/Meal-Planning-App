const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql2');

// Load environment variables
require('dotenv').config();

// Create a connection to the database
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

// Connect to the database
db.connect(err => {
    if (err) throw err;
    console.log('Connected to the database successfully.');
});

// Initialize express app
const app = express();

// Use middleware
app.use(cors());
app.use(bodyParser.json());

// Define routes
app.get('/', (req, res) => {
    res.send('Hello from the backend API!');
});

// Define a port and start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});