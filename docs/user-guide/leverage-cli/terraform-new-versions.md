# Using Terraform versions newer than 1.6.0

To use Leverage CLI with Terraform versions newer than 1.6.0 you will need to create your own docker image.

To craft such image follow these steps:

1. Create a Dockerfile in the root of your project like so:  
    ``` dockerfile
    ARG IMAGE_TAG=1.9.1-tofu-0.3.0
    FROM binbash/leverage-toolbox:$IMAGE_TAG

    ARG TERRAFORM_VERSION
    ARG PLATFORM=amd64

    RUN ["/bin/bash", "-c", "wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${PLATFORM}.zip && \
        unzip terraform_${TERRAFORM_VERSION}_linux_${PLATFORM}.zip && \
        mv terraform /usr/local/bin/ && \
        ln -s /usr/local/bin/terraform /bin/terraform && \
        terraform --version "]

    ENV UNAME=leverage
    ARG USERID
    ARG GROUPID
    RUN groupadd -g $GROUPID -o $UNAME
    RUN useradd -m -u $USERID -g $GROUPID -o -s /bin/bash $UNAME
    RUN chown -R $USERID:$GROUPID /home/leverage
    USER $UNAME
    ```

2. Build the docker image using this command:  
    ``` { .bash .copy }
    IMAGE_NAME="myimage" && \
    TERRAFORM_VERSION=1.6.6 && \
    PLATFORM="amd64" && \
    USERID=$(id -u) && \
    GROUPID=$(id -g) && \
    docker build -t ${IMAGE_NAME}:${TERRAFORM_VERSION}-${USERID}-${GROUPID} --build-arg TERRAFORM_VERSION=$TERRAFORM_VERSION --build-arg PLATFORM=$PLATFORM --build-arg USERID=$USERID --build-arg GROUPID=$GROUPID .
    ```

    !!! note "Make sure to replace `TERRAFORM_VERSION` for the desired target Terraform version"
        You can additionally change `IMAGE_NAME` and `PLATFORM` for values of your choosing.
        Even the base `binbash/leverage-toolbox` image can be selected by providing a suitable `IMAGE_TAG` build argument.

3. Change the values in your `build.env` like so:  
    ``` env
    TF_IMAGE="myimage"
    TF_IMAGE_TAG=1.6.6
    ```

    !!! important "Make sure that the values match the ones set for `IMAGE_NAME` and `TERRAFORM_VERSION` in the previous step."

4. Now you should be able to use Leverage CLI with your desired Terraform version using the `leverage terraform` command.
