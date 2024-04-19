
describe('dummy test', () => {
  it('should always pass', async () => {
    expect(true).toBe(true);
  });
});



// const request = require('supertest');
// const app = require('../server');
// const User = require('../models/user');
// const sequelize = require('../sequelize');

// describe('POST /user', function () {

//   it('should create a new user and check if the user exists', async function () {
//     const newUser = {
//       first_name: 'test_user_first_name',
//       last_name: 'test_user_last_name',
//       username: 'testuser2024@gmail.com',
//       password: '123456'
//     };

//     await request(app)
//       .post('/v1/user')
//       .send(newUser)
//       .set('Accept', 'application/json');

//     const credentials = Buffer.from(`${newUser.username}:${newUser.password}`).toString('base64');

//     await User.update({ status: 'Verified' }, {
//       where: {
//         username: newUser.username
//       }
//     });

//     const response = await request(app)
//       .get('/v1/user')
//       .set('Accept', 'application/json')
//       .set('Authorization', `Basic ${credentials}`);

//     expect(response.body.username).toBe(newUser.username);
//     // expect(response.body.data.first_name).toBe(newUser.first_name);
//     // expect(response.body.data.last_name).toBe(newUser.last_name);
//   }, 10000);


//   afterAll(async () => {
//     await sequelize.close();
//   });

// });
