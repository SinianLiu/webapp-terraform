const request = require('supertest');
const app = require('./server');


describe('GET /healthz', () => {
  it('should return 200 OK', async () => {
    const res = await request(app)
      .get('/healthz')
      .send();
    expect(res.statusCode).toEqual(200);
  });

  it('should return 400 Bad Request when payload is provided', async () => {
    const res = await request(app)
      .get('/healthz')
      .send({ key: 'value' });
    expect(res.statusCode).toEqual(400);
  });
});


describe('POST /healthz', () => {
  it('should return 405 Method Not Allowed', async () => {
    const res = await request(app)
      .post('/healthz')
      .send();
    expect(res.statusCode).toEqual(405);
  });
});