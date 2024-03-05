const { Model, DataTypes } = require('sequelize');
const bcrypt = require('bcrypt');

class User extends Model {
  static init (sequelize) {
    return super.init({
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      // username is the email address
      username: DataTypes.STRING,
      password: DataTypes.STRING,
      first_name: DataTypes.STRING,
      last_name: DataTypes.STRING,
      account_created: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      account_updated: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
    }, {
      sequelize,
      tableName: 'Users',
      timestamps: false,
      hooks: {
        beforeCreate: async (user) => {
          const salt = await bcrypt.genSalt();
          user.password = await bcrypt.hash(user.password, salt);
        },
        beforeUpdate: (user) => {
          user.account_updated = new Date();
        },
      },
    });
  }
}

module.exports = User;
