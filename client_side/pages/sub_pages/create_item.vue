<template>
  <div>
    <ul class="nav nav-tabs mb-5" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
          <button class="nav-link active" id="detail-tab" data-toggle="tab" data-target="#detail" type="button" role="tab" aria-controls="detail" aria-selected="true">Create An Item</button>
        </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link" id="spec-tab" data-toggle="tab" data-target="#spec" type="button" role="tab" aria-controls="spec" aria-selected="false">Import Items</button>
        </li>
      </ul>
      <div class="tab-content ml-4" id="myTabContent">
       <div class="tab-pane fade show active" id="detail" role="tabpanel" aria-labelledby="detail-tab">
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
                      <!-- <button @click="back" class="float-left btn btn-outline-dark">back</button> -->
                      <button type="submit" class="float-right btn btn-outline-primary">submit</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
       </div>
       <div class="tab-pane fade" id="spec" role="tabpanel" aria-labelledby="spec-tab">
        <div class="d-flex align-items-center justify-content-center" style="height: 100vh;">
            <div class="card w-50 m-auto shadow">
              <div class="card-body">
                <h3 class="my-3 col-lg-6 col-12 m-auto">Import Items</h3>
                <form class="col-lg-6 col-12 m-auto" @submit.prevent="submitForm">
                  <div class="form-group mt-4">
                    <input type="file" ref="fileInput" @change="handleFileChange" accept=".csv" />
                    <div v-if="errorMessage">
                        <span class="text-danger" v-for="error in errors.name" :key="error"> Name {{ error }}</span>
                      </div>
                  </div>
                  <div class="clearfix">
                      <!-- <button @click="back" class="float-left btn btn-outline-dark">back</button> -->
                      <button type="submit" class="float-right btn btn-outline-primary">submit</button>
                  </div>
                </form>
              </div>
            </div>
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
        image: [],
        description: '',
        price: null,
        type_name: '',
        user_id: 1
    },
    imageUrl: null,
    selectedFile: null,
    errors: [],
    errorMessage: false,
    };
},
methods: {
    imagePreview(e) {
      this.imageUrl = URL.createObjectURL(e.target.files[0])
    },
    handleFileChange(event) {
      this.selectedFile = event.target.files[0];
    },
    createCake() {
      let formData = new FormData()
      for (let [key, value] of Object.entries(this.cake)) {
        formData.append(key, value)
      }  
      this.$axios.post('/cakes', formData)
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
    submitForm(){
      if (this.selectedFile) {
        const formData = new FormData();
        formData.append("file", this.selectedFile);
        this.$axios.post('cakes/import', formData)
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
      }
    },
    back(){
      this.$router.back();
    },
    },
};
</script>

<style scoped>
/* Add your CSS styles here */
</style>
