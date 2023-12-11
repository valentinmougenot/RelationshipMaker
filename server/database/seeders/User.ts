import BaseSeeder from '@ioc:Adonis/Lucid/Seeder'
import User from 'App/Models/User'
import { randomUUID } from 'node:crypto'

export default class extends BaseSeeder {
  public async run() {
    await User.createMany([
      {
        uuid: randomUUID(),
        firstName: 'John',
        lastName: 'Doe',
        companyName: 'John Doe Inc.',
        biography: 'John Doe is a fictional character',
      },
      {
        uuid: randomUUID(),
        firstName: 'Jane',
        lastName: 'Doe',
        companyName: 'Jane Doe Inc.',
        biography: 'Jane Doe is a fictional character',
      },
    ])
  }
}
