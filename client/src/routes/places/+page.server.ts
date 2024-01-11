import type { PageServerLoad } from './$types';
import { MainApiFetcher } from '$lib/apiFetchers/MainApiFetcher';
import { PUBLIC_MAIN_API_BASE_URL } from '$env/static/public';

export type Place = {
	id: number;
	name: string;
	latitude: number;
	longitude: number;
};

export const load = (async () => {
	const fetcher = new MainApiFetcher();
	const places: Place[] = await fetcher.get('/places');

	return {
		places,
		apiBaseUrl: PUBLIC_MAIN_API_BASE_URL
	};
}) satisfies PageServerLoad;
