require('dotenv').config({ path: '/backend/src/.env'});
process.env.GOOGLE_CLIENT_ID = '627184883735-poc2od4epgn6chfsicsv43fk9nvs4kjf.apps.googleusercontent.com';
console.log('Google Client ID:', process.env.GOOGLE_CLIENT_ID);
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./config/db');
const router = express.Router();
const recipesRoutes = require('./routes/recipes_be');
const passport = require('passport');
const session = require('express-session');
require('./config/passport-setup');

// Initialize express app
const app = express();

// Use middleware
app.use(cors());
app.use(bodyParser.json());

// Define routes
app.get('/', (req, res) => {
    res.send('Hello from the backend API!');
});

app.use(session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false, maxAge: 1000 * 60 * 60 * 24 }  // adjust as needed
}));

//use the passport middleware
app.get('/auth/google', passport.authenticate('google', {
    scope: ['profile']  // Adjust scope based on the data you need (e.g., 'email')
}));

app.get('/auth/google/redirect', passport.authenticate('google'), (req, res) => {
    res.redirect('/profile/');  // Redirect to a profile page or home
});

//use the recipesRoutes
app.use('/recipes', recipesRoutes);

// Define a port and start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
