<template>
  <div>
    <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
      <div class="card w-50 m-auto shadow">
        <div class="card-body">
          <h3 class="my-3 col-lg-6 col-12 m-auto">Create An Item</h3>
          <form class="col-lg-6 col-12 m-auto" @submit.prevent="createCake">
            <div class="form-group mt-4">
              <label>Item Name</label>
              <input type="text" class="form-control" v-model="cake.name">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.name" :key="error"> Name {{ error }}</span>
                </div>
            </div>
            <div class="form-group mt-4">
              <label>Type Name</label>
              <input type="text" class="form-control" v-model="cake.type_name">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.type_name" :key="error"> Type Name {{ error }}</span>
                </div>
            </div>
            <div class="form-group mt-4">
              <label>Image</label>
              <b-img v-if="imageUrl" :src="imageUrl" fluid alt="Responsive image" class="w-100 h-100"></b-img>
              <b-form-file v-model="cake.image" class="mt-3" plain @change="imagePreview"></b-form-file>
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.image" :key="error"> Image {{ error }}</span>
                </div>
            </div>
            <div class="form-group mt-4">
              <label>Description</label>
              <input type="text" class="form-control" v-model="cake.description">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.description" :key="error"> Description {{ error }}</span>
                </div>
            </div>
            <div class="form-group mt-4">
              <label>Price</label>
              <input type="text" class="form-control" v-model="cake.price">
              <div v-if="errorMessage">
                  <span class="text-danger" v-for="error in errors.price" :key="error"> Price {{ error }}</span>
                </div>
            </div>
            <div class="clearfix">
                <button @click="back" class="float-left btn btn-outline-dark">back</button>
                <button type="submit" class="float-right btn btn-outline-primary">submit</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
data() {
    return {
    cake: {
        name: '',
        image: '',
        description: '',
        price: null,
        type_name: ''
    },
    imageUrl: null,
    errors: [],
    errorMessage: false,
    };
},
methods: {
    imagePreview(e) {
      this.imageUrl = URL.createObjectURL(e.target.files[0])
    },
    createCake() {
      this.$axios.post('/cakes', this.cake)
        .then(response => {
            this.errorMessage = false
            this.$router.push('/')
          })
          .catch(error => {
            this.errors = error.response.data
            this.errorMessage = true
            this.$notify({
              title: 'Fail',
              text: 'Something went wrong. Please try again',
              type: 'error'
            });
          })
        },
    },
    back(){
      this.$router.back();
    },
};
</script>

<style scoped>
/* Add your CSS styles here */
</style>
