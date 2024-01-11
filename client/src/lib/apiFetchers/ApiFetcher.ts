export class ApiFetcher {
	public baseUrl: string;

	constructor(baseUrl: string) {
		this.baseUrl = baseUrl;
	}

	public async get<T>(url: string): Promise<T> {
		const response = await fetch(`${this.baseUrl}${url}`);

		if (!response.ok) {
			throw new Error(response.statusText);
		}

		return await response.json();
	}

	public async postImage<T>(url: string, body: FormData): Promise<T> {
		const response = await fetch(`${this.baseUrl}${url}`, {
			method: 'POST',
			body
		});

		if (!response.ok) {
			throw new Error(response.statusText);
		}

		if (response.status === 204) {
			return null as T;
		}

		return await response.json();
	}

	public async post<T>(url: string, body: any): Promise<T> {
		const response = await fetch(`${this.baseUrl}${url}`, {
			method: 'POST',
			body: JSON.stringify(body),
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			throw new Error(response.statusText);
		}

		if (response.status === 204) {
			return null as T;
		}

		return await response.json();
	}

	public async put<T>(url: string, body: any): Promise<T> {
		const response = await fetch(`${this.baseUrl}${url}`, {
			method: 'PUT',
			body: JSON.stringify(body),
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			throw new Error(response.statusText);
		}

		if (response.status === 204) {
			return null as T;
		}

		return await response.json();
	}

	public async delete<T>(url: string): Promise<T> {
		const response = await fetch(`${this.baseUrl}${url}`, {
			method: 'DELETE',
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			throw new Error(response.statusText);
		}

		if (response.status === 204) {
			return null as T;
		}
		return await response.json();
	}
}
