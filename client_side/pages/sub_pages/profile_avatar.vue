<template>
  <div class="dropdown">
  <b-avatar size="3rem" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">{{ $auth.user.user.name.charAt(0).toUpperCase() }}</b-avatar>
  <div class="dropdown-menu dropdown-menu-right fixed-dropdown">
    <div v-if="isAdmin">
      <NuxtLink :to="{ name: 'sub_pages-confirm_orders' }" class="dropdown-item">Confirm Orders</NuxtLink>
      <hr class="hr hr-blurry" style="width: 75%;"/>
      <NuxtLink :to="{ name: 'sub_pages-create_item' }" class="dropdown-item">Create An Item</NuxtLink>
      <hr class="hr hr-blurry" style="width: 75%;"/>
    </div>
    <div v-else>
      <p class="dropdown-item text-success" >Amount: MMK {{ amount }} </p>
      <hr class="hr hr-blurry" style="width: 75%;"/> 
    </div>
    <NuxtLink :to="{ name: 'sub_pages-profile_update' }" class="dropdown-item">Profile Update</NuxtLink>
    <hr class="hr hr-blurry" style="width: 75%;"/>
    <a class="dropdown-item" @click="logout" href="#" ><font-awesome-icon icon="reply" class="mr-2 text-danger" /> Logout</a>
  </div>
  </div>
</template>
<script>
export default{
  props: {
    amount: ''
  },
  data(){
    return{
      isAdmin: false
    }
  },
  methods: {
    async logout(){
      await this.$auth.logout();
      this.$notify({
          title: 'Success',
          text: 'Logout successful',
        });
      this.$router.push('/')
    },
  },
  mounted() {
    if(this.$auth.loggedIn)
    {
      this.isAdmin = this.$auth.user.user.role === 'admin' ? true : false;
    }
  }

}
</script>
<style>
    .dropdown-toggle::after {
      content: none;
    }
    .fixed-dropdown {
      max-height: unset !important; /* Override Bootstrap's max-height */
      overflow-y: visible !important; /* Override Bootstrap's overflow */
    }
</style>