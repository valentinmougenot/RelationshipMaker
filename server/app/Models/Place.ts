import { BaseModel, HasMany, column, hasMany } from '@ioc:Adonis/Lucid/Orm'
import User from './User'

export default class Place extends BaseModel {
  @column({ isPrimary: true })
  public id: number

  @column()
  public name: string

  @column()
  public lattitude: number

  @column()
  public longitude: number

  @hasMany(() => User)
  public users: HasMany<typeof User>
}
