<script lang="ts">
	import '@fortawesome/fontawesome-free/css/all.min.css';
	import type { PageData } from './$types';
	import type { User } from './+page.server';
	import type { Field } from '$lib/types/field';
	import FormModalAddUpdate from '$lib/Modals/FormModalAddUpdate.svelte';
	import FormModalDelete from '$lib/Modals/FormModalDelete.svelte';
	import { ApiFetcher } from '$lib/apiFetchers/ApiFetcher';
	export let data: PageData;

	const fetcher = new ApiFetcher(data.apiBaseUrl);

	type FieldUserNameType = keyof User;

	const fields: Field<FieldUserNameType>[] = [
		{ name: 'firstName', label: 'Prénom' },
		{ name: 'lastName', label: 'Nom' },
		{ name: 'companyName', label: 'Entreprise' },
		{ name: 'biography', label: 'Biographie' }
	];

	let editedUser: User = {
		id: 0,
		firstName: '',
		lastName: '',
		companyName: '',
		biography: '',
		avatarUrl: '',
		placeId: null
	};
	let editModal: FormModalAddUpdate;
	const showEditModal = (id: number) => {
		editedUser = data.users.find((user) => user.id === id) as User;
		editModal.showModal();
	};
	const submitEdit = async () => {
		try {
			await fetcher.put(`/users/${editedUser!.id}`, editedUser);

			data.users = data.users.map((user) => {
				if (user.id === editedUser?.id) {
					return editedUser;
				}
				return user;
			});

			editedUser = {
				id: 0,
				firstName: '',
				lastName: '',
				companyName: '',
				biography: '',
				avatarUrl: '',
				placeId: null
			};
		} catch (err) {
			console.error(err);
		}

		editModal.close();
	};

	const updatePlaceId = async (event: Event, userId: number) => {
		const select = event.target as HTMLSelectElement;
		const placeId = select.value;
		const user = data.users.find((user) => user.id === userId) as User;
		user.placeId = placeId === 'null' ? null : parseInt(placeId);
		try {
			await fetcher.put(`/users/${user.id}`, user);
		} catch (err) {
			console.error(err);
		}
	};

	let addedUser: User = {
		id: 0,
		firstName: '',
		lastName: '',
		companyName: '',
		biography: '',
		avatarUrl: '',
		placeId: null
	};
	let addModal: FormModalAddUpdate;
	const showAddModal = () => {
		addModal.showModal();
	};
	const submitAdd = async () => {
		try {
			const addedUserData: User = await fetcher.post('/users', addedUser);
			data.users = [...data.users, addedUserData];
			addedUser = {
				id: 0,
				firstName: '',
				lastName: '',
				companyName: '',
				biography: '',
				avatarUrl: '',
				placeId: null
			};
		} catch (err) {
			console.error(err);
		}

		addModal.close();
	};

	let deletedUserId: number | null = null;
	let deleteModal: FormModalDelete;
	const showDeleteModal = (id: number) => {
		deletedUserId = id;
		deleteModal.showModal();
	};
	const submitDelete = async () => {
		try {
			await fetcher.delete(`/users/${deletedUserId}`);
			data.users = data.users.filter((user) => user.id !== deletedUserId);
			deletedUserId = null;
		} catch (err) {
			console.error(err);
		}

		deleteModal.close();
	};

	let avatarUserId: number | null = null;
	let avatarUploadModal: HTMLDialogElement;
	let avatarUplaoadFileInput: HTMLInputElement;
	const showAvatarUploadModal = () => {
		avatarUploadModal.showModal();
	};
	const closeAvatarUploadModal = () => {
		avatarUploadModal.close();
	};

	const submitAvatarUpload = async () => {
		try {
			const formData = new FormData();
			formData.append('avatar', avatarUplaoadFileInput.files![0]);
			const { avatarUrl } = await fetcher.postImage<{ avatarUrl: string }>(
				`/users/${avatarUserId}/avatar`,
				formData
			);
			data.users = data.users.map((user) => {
				if (user.id === avatarUserId) {
					user.avatarUrl = avatarUrl;
				}
				return user;
			});
			avatarUserId = null;
		} catch (err) {
			console.error(err);
		}

		deleteModal.close();
	};

	const submitDeleteAvatar = async () => {
		try {
			await fetcher.delete(`/users/${avatarUserId}/avatar`);
			data.users = data.users.map((user) => {
				if (user.id === avatarUserId) {
					user.avatarUrl = null;
				}
				return user;
			});
			avatarUserId = null;
		} catch (err) {
			console.error(err);
		}

		deleteModal.close();
	};
</script>

<h1 class="text-4xl">Utilisateurs</h1>

<button class="btn btn-primary my-4" on:click={showAddModal}>Nouvel utilisateur</button>

<div class="overflow-x-auto">
	<table class="table">
		<thead>
			<tr>
				<th class="p-4">Avatar</th>
				{#each fields as field}
					<th class="p-4">{field.label}</th>
				{/each}
				<th class="p-4">Lieu</th>
				<th class="p-4">Actions</th>
			</tr>
		</thead>
		<tbody>
			{#each data.users as user}
				<tr class="hover">
					<td class="p-4">
						<button
							class="btn btn-sm btn-circle btn-ghost"
							on:click={() => {
								avatarUserId = user.id;
								showAvatarUploadModal();
							}}
						>
							{#if user.avatarUrl}
								<img
									class="w-8 h-8 rounded-full"
									src="{fetcher.baseUrl}{user.avatarUrl}"
									alt="Avatar"
								/>
							{:else}
								<img class="w-8 h-8 rounded-full" src="/avatar.png" alt="Avatar" />
							{/if}
						</button>
					</td>
					{#each fields as field}
						<td class="p-4">{user[field.name]}</td>
					{/each}
					<td class="p-4">
						<select
							class="select w-full max-w-xs"
							on:change={(event) => updatePlaceId(event, user.id)}
						>
							<option selected={user.placeId === null}>Aucun</option>
							{#each data.places as place}
								<option value={place.id} selected={place.id === user.placeId}>{place.name}</option>
							{/each}
						</select>
					</td>
					<td class="text-center p-4">
						<button on:click={() => showEditModal(user.id)}
							><i class="fa-solid fa-pen hover:cursor-pointer hover:text-primary duration-200"
							></i></button
						>
						<button on:click={() => showDeleteModal(user.id)}
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
	title="Modifier un utilisateur"
	{fields}
	item={editedUser}
	onSubmit={submitEdit}
	onClose={() =>
		(editedUser = {
			id: 0,
			firstName: '',
			lastName: '',
			companyName: '',
			biography: '',
			avatarUrl: '',
			placeId: null
		})}
/>

<FormModalAddUpdate
	bind:this={addModal}
	title="Ajouter un utilisateur"
	{fields}
	item={addedUser}
	onSubmit={submitAdd}
	onClose={() =>
		(addedUser = {
			id: 0,
			firstName: '',
			lastName: '',
			companyName: '',
			biography: '',
			avatarUrl: '',
			placeId: null
		})}
/>

<FormModalDelete
	bind:this={deleteModal}
	title="Supprimer un utilisateur"
	content="Êtes-vous sûr de vouloir supprimer cet utilisateur ?"
	onSubmit={submitDelete}
	onClose={() => (deletedUserId = null)}
/>

<dialog class="modal" bind:this={avatarUploadModal}>
	<div class="modal-box">
		<form method="dialog">
			<button
				class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2"
				on:click={closeAvatarUploadModal}>✕</button
			>
		</form>
		<h3 class="font-bold text-lg">Modifier l'avatar</h3>
		<input
			type="file"
			class="file-input file-input-bordered w-full max-w-xs"
			accept="image/*"
			required
			bind:this={avatarUplaoadFileInput}
		/>
		<form class="modal-action" method="dialog">
			<button class="btn btn-error mt-4" on:click={submitDeleteAvatar}>Supprimer</button>
			<button class="btn btn-primary mt-4" on:click={submitAvatarUpload}>Envoyer</button>
		</form>
	</div>
</dialog>
