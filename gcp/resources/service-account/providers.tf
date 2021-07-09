provider "google" {
  batching {
    enable_batching = false
  }
}

provider "google-beta" {
    batching {
    enable_batching = false
  }
}