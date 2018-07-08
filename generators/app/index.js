var Generator = require('yeoman-generator');
module.exports = class extends Generator {
    // The name `constructor` is important here
    constructor(args, opts) {
        // Calling the super constructor is important so our generator is correctly set up
        super(args, opts);

        this.output = {
            type: ''
        }
    }

    prompting() {
        return this.prompt([{
            type: 'list',
            name: 'type',
            message: 'What would you like to terraform ?',
            choices: ['EC2', 'S3', 'ALB', 'RDS']
        }
        ]).then((answers) => {

            switch (answers.type) {
                case 'EC2': {
                    this.composeWith(require.resolve('../ec2'));
                    break
                }
                case 'S3': {
                    this.composeWith(require.resolve('../s3'));
                    break
                }
                case 'ALB': {
                    this.composeWith(require.resolve('../alb'));
                    break
                }
                case 'RDS': {
                    this.composeWith(require.resolve('../rds'));
                    break
                }
            }

            this.output.type = answers.type;
            this.log('Type', this.output.type);
        });
    }
}