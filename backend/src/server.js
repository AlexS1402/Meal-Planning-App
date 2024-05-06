const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./config/db');
const recipesRoutes = require('./routes/recipes-be');
const loginRoutes = require('./routes/login-be');
const mealPlansRoutes = require('./routes/mealplans-be');
const router = express.Router();
const session = require('express-session');
const nutritionRoutes = require('./routes/nutritions-be');
require('dotenv').config();

// Initialize express app
const app = express();

// Use middleware
app.use(cors());
app.use(bodyParser.json());

// Define routes
app.get('/', (req, res) => {
    res.send('Hello from the backend API!');
});

// use the session middleware
app.use(session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: true,
    cookie: { secure: true } // Set to true if you're using HTTPS
  }));

// Logout route
app.get("/logout", (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).send("Failed to log out");
    }
    res.send("Logged out successfully");
  });
});

//use the loginRoutes
app.use('/auth', loginRoutes);

//use the mealplanRoutes
app.use('/mealplans', mealPlansRoutes);

//use the recipesRoutes
app.use('/recipes', recipesRoutes);

//use the nutritionRoutes
app.use('/nutrition-chart', nutritionRoutes);

// Define a port and start the server
const PORT = 3001;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
