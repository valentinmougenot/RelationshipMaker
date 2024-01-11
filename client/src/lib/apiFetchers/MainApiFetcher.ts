import { ApiFetcher } from './ApiFetcher';

export class MainApiFetcher extends ApiFetcher {
	constructor() {
		super('http://server:3333');
	}
}
