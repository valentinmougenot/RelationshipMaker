import type { HttpContextContract } from '@ioc:Adonis/Core/HttpContext'
import Place from 'App/Models/Place'
import User from 'App/Models/User'

export default class PlacesController {
  public async getAllPlaces({ response }: HttpContextContract) {
    const places = await Place.all()
    return response.ok(places)
  }

  public async getUsersByPlace({ response, params }: HttpContextContract) {
    const users = await User.query().where('place_id', params.id)
    return response.ok(users)
  }
}
