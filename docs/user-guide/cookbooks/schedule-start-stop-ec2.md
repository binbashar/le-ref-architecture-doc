# Start/Stop EC2/RDS instances using schedule or manual endpoint

## What?

You have EC2 instances (or RDS) that are not being used all the time... so why to keep them up and running and billing?
Here we'll create a simple schedule to turn them off/on. (also with an HTTP endpoint to do it so manually)

## Why?

To keep your billing under control!

## How?

### Pre-requisites

All the instances you want to start stop have to be tagged accordingly. For this example we'll use these tags:

```yaml
    ScheduleStopDaily   = true
    ScheduleStartManual = true
```

### The scheduler layer

In your  [**binbash Leverage**](https://leverage.binbash.co/)  infra repository, under your desired account and region, copy [this layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/us-east-1/tools-cloud-scheduler-stop-start).

You can download a directory from a git repository using [this Firefox addon](https://addons.mozilla.org/en-US/firefox/addon/gitzip/) or any method you want.

Remember, if the `common-variables.tf` file delete the file and soft-link it to the homonymous file in the root `config` dir: e.g. `common-variables.tf -> ../../../config/common-variables.tf`

### Set the tags

In the `tools-cloud-scheduler-stop-start` layer edit the `main.tf` file.
There are two resources:
- `schedule_ec2_stop_daily_midnight` to stop the instances
- `schedule_ec2_start_daily_morning` to start the instances

You can change these names. If you do so remember to change all the references to them.

In the `resource_tags` element set the right tags. E.g. this:
```yaml
  resources_tag = {
    key   = "ScheduleStopDaily"
    value = "true"
  }
```
in the `schedule_ec2_stop_daily_midnight` resource means this resource will stop instances with tag: `ScheduleStopDaily=true`.

### Set the schedule

Note this line:
```yaml
  cloudwatch_schedule_expression = "cron(0 23 * * ? *)"
```

Here you can set the schedule in a cron-like fashion.

If it is `none` it won't create a schedule (e.g. if you only need http endpoint):
```yaml
  cloudwatch_schedule_expression = "none"
```

Then if you set this:
```yaml
  http_trigger = true
```

A HTTP endpoint will be created to trigger the corresponding action.

If an endpoint was created then in the outputs the URL will be shown.

