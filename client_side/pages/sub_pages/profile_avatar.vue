<template>
  <div class="dropdown">
  <b-avatar size="3rem" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">{{ $auth.user.user.name.charAt(0).toUpperCase() }}</b-avatar>
  <div class="dropdown-menu dropdown-menu-right">
    <a class="dropdown-item" href="#">Action</a>
    <NuxtLink :to="{ name: 'sub_pages-profile_update' }" class="dropdown-item">Profile Update</NuxtLink>
    <a class="dropdown-item" @click="logout" href="#" ><font-awesome-icon icon="reply" class="mr-2 text-danger" /> Logout</a>
  </div>
  </div>
</template>
<script>
export default{
  data(){
    return{

    }
  },
  methods: {
    async logout(){
      await this.$auth.logout();
      this.$notify({
          title: 'Success',
          text: 'Logout successful',
        });
      this.$router.push('/login')
    },
  },

}
</script>
<style>
    .dropdown-toggle::after {
      content: none;
    }
</style>