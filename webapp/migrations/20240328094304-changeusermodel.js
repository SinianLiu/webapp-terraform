'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.addColumn('Users', 'token', {
      type: Sequelize.STRING,
    });
    await queryInterface.addColumn('Users', 'token_creation_time', {
      type: Sequelize.DATE,
    });
    await queryInterface.addColumn('Users', 'token_expiration_time', {
      type: Sequelize.DATE,
    });
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.removeColumn('Users', 'token');
    await queryInterface.removeColumn('Users', 'token_creation_time');
    await queryInterface.removeColumn('Users', 'token_expiration_time');
  }
};
