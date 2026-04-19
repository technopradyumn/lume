const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');

async function test() {
  try {
    const form = new FormData();
    form.append('fullName', 'test name');
    form.append('email', 'testemail123@gmail.com');
    form.append('username', 'testuser123');
    form.append('password', '123456');

    // Make request
    const response = await axios.post('http://localhost:8000/api/v1/users/register', form, {
      headers: {
        ...form.getHeaders()
      }
    });

    console.log("SUCCESS:", response.status, response.data);
  } catch (error) {
    if (error.response) {
      console.log("ERROR STATUS:", error.response.status);
      console.log("ERROR DATA:", error.response.data);
    } else {
      console.log("ERROR:", error.message);
    }
  }
}

test();
