# Hi Yakov Antipenko. This is your test assignment.

You have up to 5 days for this test assignment. If there are any questions - let us know, we will try to help.
5 days doesn't mean that you will spend all 5 days on this, we take into account that people have their own work/availability to work on the assignment.
After 5 days are passed , please provide us a link to the MR in the repo. Even if you didn't finish the task completely after - send the link anyway, the way of thinking is more important for us then completion for 100%.
The task is not very simple, it's very close to the real-world scenario. We hope that using technologies described below will make it interesting for you, instead of standard questions like "create a bash script" or "write code in Python" or "create a Dockerfile".

# The Assignment

In the repository you can find the `web` directory. It is a static website which can be connected to the Contentful CMS.

Technology stack that you must use:
- Gitlab Actions
- static website + CMS
- AWS ( S3 + Cloudfront)
- Pulumi/AWS CDK (you should pick one yourself)

Your task is to setup CI/CD process in such a way, that for each push to master branch in the repository - GitLab CI are triggered, it should build the website and deploy it to AWS S3 + Cloudfront.
S3+Cloudfront must be created and updated with Infrastructure as Code technology, you can pick one of 2 technologies AWS CDK or Pulumi (Cloudformation or Terraform cannot be used )
To make sure that Contentful CMS is connected properly - please add custom texts/images to the deployed website.
Ideal assignment should be as follows - you upload code to master, checkout from master to new branch, add some changes and create MR, in description of MR create a todo list of items you will do to finish the MR, as you proceed with test assignments - push your commits in time, so we can see clear history of changes in the git commits. After you finalized the work - add link to your cloudfront distribution , make sure GitLab CI pass and don't give errors, add any comments that can be relevant in the description of the MR
Don't try to hide your mistakes in git history, this is quite difficult task, everybody makes mistakes, and for us it is important how you troubleshoot problems and fix them when they occur
During review we will analyze your approach to the work with git, commit messages, frequency of commits, and so on.

Good luck!
