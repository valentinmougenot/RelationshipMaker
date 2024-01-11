import BaseSeeder from '@ioc:Adonis/Lucid/Seeder'
import Place from 'App/Models/Place'

export default class extends BaseSeeder {
  public async run() {
    await Place.createMany([
      {
        name: 'La Rascasse',
        latitude: 43.73262434635189,
        longitude: 7.423291293391258,
      },
      {
        name: 'Starbucks',
        latitude: 43.73253927001143,
        longitude: 7.417859836350384,
      },
      {
        name: "Steak 'n Shake Monaco",
        latitude: 43.736603170740175,
        longitude: 7.421324398571294,
      },
      {
        name: 'Casino de Monte-Carlo',
        latitude: 43.739213134778645,
        longitude: 7.428120137898606,
      },
    ])
  }
}
