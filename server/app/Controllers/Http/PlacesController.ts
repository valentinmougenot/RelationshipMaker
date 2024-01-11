import type { HttpContextContract } from '@ioc:Adonis/Core/HttpContext'
import Place from 'App/Models/Place'
import User from 'App/Models/User'

export default class PlacesController {
  public async getAllPlaces({ response }: HttpContextContract) {
    const places = await Place.all()
    return response.ok(places)
  }

  public async createPlace({ request, response }: HttpContextContract) {
    const { name, latitude, longitude } = request.body()
    const place = await Place.create({ name, latitude, longitude })
    return response.created(place)
  }

  public async updatePlace({ params, request, response }: HttpContextContract) {
    const place = await Place.findOrFail(params.id)
    if (!place) {
      return response.notFound()
    }

    const { name, latitude, longitude } = request.body()
    place.name = name
    place.latitude = latitude
    place.longitude = longitude
    await place.save()
    return response.noContent()
  }

  public async deletePlace({ params, response }: HttpContextContract) {
    const place = await Place.findOrFail(params.id)
    if (!place) {
      return response.notFound()
    }

    await place.delete()
    return response.noContent()
  }

  public async getUsersByPlace({ response, params }: HttpContextContract) {
    const users = await User.query().where('place_id', params.id)
    return response.ok(users)
  }
}
