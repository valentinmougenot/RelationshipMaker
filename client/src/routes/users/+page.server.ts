import type { PageServerLoad } from './$types';
import { MainApiFetcher } from '$lib/apiFetchers/MainApiFetcher';
import { PUBLIC_MAIN_API_BASE_URL } from '$env/static/public';

export type User = {
	id: number;
	firstName: string;
	lastName: string;
	companyName: string | null;
	biography: string | null;
	avatarUrl: string | null;
	placeId: number | null;
};

export type Place = {
	id: number;
	name: string;
	latitude: number;
	longitude: number;
};

export const load = (async () => {
	const fetcher = new MainApiFetcher();
	const users: User[] = await fetcher.get('/users');
	const places: Place[] = await fetcher.get('/places');

	return {
		users,
		places,
		apiBaseUrl: PUBLIC_MAIN_API_BASE_URL
	};
}) satisfies PageServerLoad;
