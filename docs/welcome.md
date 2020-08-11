---
template: overrides/main.html
---

![binbash-logo](./assets/images/logos/binbash.png "Binbash"){: style="width:250px"}
![binbash-leverage-tf](./assets/images/logos/binbash-leverage-terraform.png#right "Leverage"){: style="width:130px"}

# Welcome
This is the documentation for the **Leverage Reference Architecture**.

It is built around the [AWS Well Architected Framework](https://aws.amazon.com/architecture/well-architected/)
, using a [Terraform](https://www.terraform.io/), [Ansible](https://www.ansible.com/) and [Helm](https://helm.sh/).

An its compose of the following 3 main repos:

- [x] [le-tf-infra-aws](https://github.com/binbashar/le-tf-infra-aws)
- [x] [le-ansible-infra](https://github.com/binbashar/le-ansible-infra)
- [x] [le-helm-infra](https://github.com/binbashar/le-helm-infra)

## Getting Started
:books: See [**How it works**](./how-it-works/index.md) for a whirlwind tour that will get you started.

:books: See [**User guide**](./user-guide/index.md) for a hands on help.


---
### :art: Color Settings

The color scheme will be set based on user preference, which makes use of the `prefers-color-scheme` media query. 

!!! info "How to setup Dark mode | Dark theme"
    * [x] [Google Chrome | Browse in Dark mode or Dark theme](https://support.google.com/chrome/answer/9275525)
    * [x] [How to enable dark mode on your phone, laptop, and more](https://www.theverge.com/2019/3/22/18270975/how-to-dark-mode-iphone-android-mac-windows-xbox-ps4-nintendo-switch)

#### :art: Try it yourself
:material-cursor-default-click-outline: Click on below presented buttons to change the color
scheme

<div class="tx-switch">
  <button data-md-color-scheme="default"><code>default-theme | day-mode</code></button>
  <br>
  <button data-md-color-scheme="slate"><code>dark-theme &nbsp&nbsp | night-mode</code></button>
</div>

<script>
  var buttons = document.querySelectorAll("button[data-md-color-scheme]")
  buttons.forEach(function(button) {
    button.addEventListener("click", function() {
      var attr = this.getAttribute("data-md-color-scheme")
      document.body.setAttribute("data-md-color-scheme", attr)
      var name = document.querySelector("#__code_0 code span:nth-child(7)")
      name.textContent = attr
    })
  })
</script>
