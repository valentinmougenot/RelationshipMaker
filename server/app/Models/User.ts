import { BaseModel, column } from '@ioc:Adonis/Lucid/Orm'

export default class User extends BaseModel {
  @column({ isPrimary: true })
  public id: number

  @column()
  public uuid: string

  @column()
  public firstName: string

  @column()
  public lastName: string

  @column()
  public companyName?: string

  @column()
  public biography?: string

  @column()
  public avatarUrl?: string

  @column()
  public placeId?: number
}
