import logo from './logo.svg';
import './App.css';

import React, { useState, useEffect } from 'react';


function App() {
  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState({ title: '', description: '' });

  useEffect(() => {
    fetchTasks();
  }, []);

  const fetchTasks = () => {
    fetch('http://192.168.0.106:5000/tasks')
      .then(response => response.json())
      .then(data => {
        setTasks(data.tasks);
      })
      .catch(error => {
        console.error('Error fetching data:', error);
      });
  };

  const handleInputChange = e => {
    const { name, value } = e.target;
    setNewTask({ ...newTask, [name]: value });
  };

  const handleSubmit = e => {
    e.preventDefault();
    fetch('http://192.168.0.106:5000/tasks', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(newTask),
    })
      .then(response => response.json())
      .then(data => {
        console.log('New task added:', data.task);
        fetchTasks(); // Fetch updated task list
        setNewTask({ title: '', description: '' }); // Clear form inputs
      })
      .catch(error => {
        console.error('Error adding task:', error);
      });
  };

  return (
    <div className="container">
      <header className="App-header">
        <div class="logo">
          <img src={logo} className="logo" alt="logo" />
          <h1>Tasks</h1>
        </div>
        </header>
       <ul className="task-list">
        {tasks.map(task => (
          <li key={task.id} className="task-item">
            <strong>{task.title}</strong> - {task.description}
          </li>
        ))}
      </ul>
      <form onSubmit={handleSubmit}>
        <h2>Add New Task</h2>
        <label>
          Title:
          <input
            type="text"
            name="title"
            value={newTask.title}
            onChange={handleInputChange}
            required
          />
        </label>
        <label>
          Description:
          <input
            type="text"
            name="description"
            value={newTask.description}
            onChange={handleInputChange}
          />
        </label>
        <button type="submit">Add Task</button>
      </form>
    </div>
  );
}

export default App;
