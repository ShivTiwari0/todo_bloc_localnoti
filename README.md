# ToDoList App

Welcome to the ToDoList App! This Flutter application allows users to manage their tasks efficiently with features such as adding, editing, deleting, sorting, and searching tasks. The app leverages the power of Cubit for state management and SQLite for local data storage.

## Features

- **Add New Tasks**: Create new tasks with titles, descriptions, priority levels, due dates, and reminders.
- **Edit Tasks**: Modify existing tasks to update their details.
- **Delete Tasks**: Remove tasks from the list when they are no longer needed.
- **Sort Tasks**: Organize tasks by priority or due date.
- **Search Tasks**: Find tasks by title using a dynamic search bar.
- **Reminders**: Schedule notifications to remind you of upcoming tasks.
- **Persistent Storage**: Data is stored locally using SQLite.

## Screenshots

![Home Screen](assets/screenshots/home_screen.jpeg)
![Add/Edit Task Screen](assets/screenshots/add_task_screen.jpeg)

## Getting Started

To get started with the ToDoList app, follow these steps:

### Prerequisites

- Flutter SDK
- Dart
- SQLite database

### Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/todolist_app.git
    ```

2. **Navigate to the project directory:**

    ```bash
    cd todolist_app
    ```

3. **Install dependencies:**

    ```bash
    flutter pub get
    ```

4. **Run the app:**

    ```bash
    flutter run
    ```

## Code Structure

- `lib/` - Contains the main source code for the app.
  - `core/` - Core functionalities and services.
  - `data/` - Data models and database helper.
  - `logic/` - Cubit classes and states for state management.
  - `presentation/` - UI components and screens.
- `assets/` - Contains images and screenshots used in the app.

## Code Examples

### Adding a Task

```dart
BlocProvider.of<TaskCubit>(context).addTask(newTask);

### Updating a Task
BlocProvider.of<TaskCubit>(context).updateTask(updatedTask);


### Scheduling a Notification
NotificationService.showScheduleNotification(
  title: "Your task '$_title' is due soon",
  body: "Priority is ${_priority.toString().split('.').last.toUpperCase()}",
  payload: _description,
  scheduledTime: notificationTime,
);



Feel free to copy and adjust the content as needed.


