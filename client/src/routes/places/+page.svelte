<script lang="ts">
	import '@fortawesome/fontawesome-free/css/all.min.css';
	import type { PageData } from './$types';
	import type { Place } from './+page.server';
	import type { Field } from '$lib/types/field';
	import FormModalAddUpdate from '$lib/Modals/FormModalAddUpdate.svelte';
	import FormModalDelete from '$lib/Modals/FormModalDelete.svelte';
	import { ApiFetcher } from '$lib/apiFetchers/ApiFetcher';
	export let data: PageData;

	const fetcher = new ApiFetcher(data.apiBaseUrl);

	type FieldPlaceNameType = keyof Place;

	const fields: Field<FieldPlaceNameType>[] = [
		{ name: 'name', label: 'Nom' },
		{ name: 'latitude', label: 'Latitude' },
		{ name: 'longitude', label: 'Longitude' }
	];

	let editedPlace: Place = {
		id: 0,
		name: '',
		latitude: 0,
		longitude: 0
	};
	let editModal: FormModalAddUpdate;
	const showEditModal = (id: number) => {
		editedPlace = data.places.find((place) => place.id === id) as Place;
		editModal.showModal();
	};
	const submitEdit = async () => {
		try {
			await fetcher.put(`/places/${editedPlace.id}`, editedPlace);

			data.places = data.places.map((place) => {
				if (place.id === editedPlace?.id) {
					return editedPlace;
				}
				return place;
			});

			editedPlace = {
				id: 0,
				name: '',
				latitude: 0,
				longitude: 0
			};
		} catch (err) {
			console.error(err);
		}

		editModal.close();
	};

	let addedPlace: Place = {
		id: 0,
		name: '',
		latitude: 0,
		longitude: 0
	};
	let addModal: FormModalAddUpdate;
	const showAddModal = () => {
		addModal.showModal();
	};
	const submitAdd = async () => {
		try {
			const addedPlaceData: Place = await fetcher.post('/places', addedPlace);
			data.places = [...data.places, addedPlaceData];
			addedPlace = {
				id: 0,
				name: '',
				latitude: 0,
				longitude: 0
			};
		} catch (err) {
			console.error(err);
		}

		addModal.close();
	};

	let deletedPlaceId: number | null = null;
	let deleteModal: FormModalDelete;
	const showDeleteModal = (id: number) => {
		deletedPlaceId = id;
		deleteModal.showModal();
	};
	const submitDelete = async () => {
		try {
			await fetcher.delete(`/places/${deletedPlaceId}`);
			data.places = data.places.filter((place) => place.id !== deletedPlaceId);
			deletedPlaceId = null;
		} catch (err) {
			console.error(err);
		}

		deleteModal.close();
	};
</script>

<h1 class="text-4xl">Places</h1>

<button class="btn btn-primary my-4" on:click={showAddModal}>Nouveau lieu</button>

<div class="overflow-x-auto">
	<table class="table">
		<thead>
			<tr>
				{#each fields as field}
					<th class="p-4">{field.label}</th>
				{/each}
				<th class="p-4">Actions</th>
			</tr>
		</thead>
		<tbody>
			{#each data.places as place}
				<tr class="hover">
					{#each fields as field}
						<td class="p-4">{place[field.name]}</td>
					{/each}
					<td class="text-center p-4">
						<button on:click={() => showEditModal(place.id)}
							><i class="fa-solid fa-pen hover:cursor-pointer hover:text-primary duration-200"
							></i></button
						>
						<button on:click={() => showDeleteModal(place.id)}
							><i class="fa-solid fa-trash hover:cursor-pointer hover:text-error duration-200"
							></i></button
						>
					</td>
				</tr>
			{/each}
		</tbody>
	</table>
</div>

<FormModalAddUpdate
	bind:this={editModal}
	title="Modifier un lieu"
	{fields}
	item={editedPlace}
	onSubmit={submitEdit}
	onClose={() => (editedPlace = { id: 0, name: '', latitude: 0, longitude: 0 })}
/>

<FormModalAddUpdate
	bind:this={addModal}
	title="Ajouter un lieu"
	{fields}
	item={addedPlace}
	onSubmit={submitAdd}
	onClose={() => (addedPlace = { id: 0, name: '', latitude: 0, longitude: 0 })}
/>

<FormModalDelete
	bind:this={deleteModal}
	title="Supprimer un lieu"
	content="Êtes-vous sûr de vouloir supprimer ce lieu ?"
	onSubmit={submitDelete}
	onClose={() => (deletedPlaceId = null)}
/>
