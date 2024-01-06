import BaseSchema from '@ioc:Adonis/Lucid/Schema'

export default class extends BaseSchema {
  protected tableName = 'users'

  public async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id')
      table.string('first_name').notNullable()
      table.string('last_name').notNullable()
      table.string('company_name').nullable()
      table.text('biography').nullable()
      table.string('avatar_url').nullable()
      table
        .integer('place_id')
        .nullable()
        .unsigned()
        .references('id')
        .inTable('places')
        .onDelete('CASCADE')
    })
  }

  public async down() {
    this.schema.dropTable(this.tableName)
  }
}
