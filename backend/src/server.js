const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./config/db');
const recipesRoutes = require('./routes/recipes-be');
const loginRoutes = require('./routes/login-be');
const mealPlansRoutes = require('./routes/mealplans-be');
const router = express.Router();

// Initialize express app
const app = express();

// Use middleware
app.use(cors());
app.use(bodyParser.json());

// Define routes
app.get('/', (req, res) => {
    res.send('Hello from the backend API!');
});

//use the loginRoutes
app.use('/api/auth', loginRoutes);

//use the mealplanRoutes
app.use('/mealplans', mealPlansRoutes);

//use the recipesRoutes
app.use('/recipes', recipesRoutes);

// Define a port and start the server
const PORT = 3001;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
