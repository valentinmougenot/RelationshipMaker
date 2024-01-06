import BaseSeeder from '@ioc:Adonis/Lucid/Seeder'
import User from 'App/Models/User'

export default class extends BaseSeeder {
  public async run() {
    await User.createMany([
      {
        firstName: 'John',
        lastName: 'Doe',
        companyName: 'John Doe Inc.',
        biography: 'John Doe is a fictional character',
      },
      {
        firstName: 'Jane',
        lastName: 'Doe',
        companyName: 'Jane Doe Inc.',
        biography: 'Jane Doe is a fictional character',
      },
    ])
  }
}
