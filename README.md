# Meal Planning App

## Overview
This application is designed to help users plan their meals efficiently by managing recipes, tracking nutritional intake, and offering personalized recipe suggestions. Built with Flutter for the frontend and Node.js for the backend, the app integrates MySQL hosted on Azure for data management.

## Features
- **User Authentication**: Secure login and registration system with session management.
- **Meal Planning**: Users can add, edit, and delete meal plans, track nutritional details, and view meal plan history.
- **Recipe Management**: Users can add, edit, and delete their personal recipes. Recipes are linked to user IDs for personalized management.
- **Nutritional Tracking**: Interface for tracking daily nutritional intake with graphical data representation.
- **Recipe Suggestions**: Personalized recipe suggestions based on user preferences and ingredients on hand, powered by OpenAI's API.
- **Push Notifications**: Timely reminders and notifications to enhance user engagement.

## Technologies Used
- **Frontend**: Flutter
- **Backend**: Node.js, Express.js
- **Database**: MySQL, hosted on Azure
- **Authentication**: Custom authentication with bcrypt for hashing passwords
- **API**: Integration with OpenAI for generating recipe suggestions
- **Additional Libraries**: Chart.js for nutritional tracking charts

## Installation

### Prerequisites
- Node.js
- Flutter
- MySQL
- An Azure account for MySQL hosting
- An OpenAI API key

### Setting Up the Backend
1. Clone the repository:
git clone https://github.com/yourusername/meal-planning-app.git

css
Copy code
2. Navigate to the backend directory:
cd meal-planning-app/backend

markdown
Copy code
3. Install dependencies:
npm install

markdown
Copy code
4. Set up environment variables:
- Rename `.env.example` to `.env`
- Fill in your MySQL credentials and OpenAI API key in `.env`

5. Start the server:
npm start
redis-server

markdown
Copy code

### Setting Up the Frontend
1. Navigate to the frontend directory:
cd meal-planning-app/frontend

markdown
Copy code
2. Install Flutter dependencies:
flutter pub get

markdown
Copy code
3. Run the Flutter application:
flutter run

less
Copy code

## Usage
After starting both the frontend and backend, navigate to the app in your web browser or use a mobile device to access the Flutter application. Register a new user account to begin planning meals, adding recipes, and tracking nutritional intake.

## Contact
Your Name - [your-email@example.com](mailto:your-email@example.com)

Project Link: [https://github.com/AlexS1402/meal-planning-app](https://github.com/AlexS1402/meal-planning-app)

## Acknowledgments
- OpenAI for providing the API used for generating recipe suggestions
- Chart.js for the graphical representations of nutritional data
