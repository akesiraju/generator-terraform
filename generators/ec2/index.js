var EC2Generator = require('yeoman-generator');
module.exports = class extends EC2Generator {
    // The name `constructor` is important here
    constructor(args, opts) {
        // Calling the super constructor is important so our generator is correctly set up
        super(args, opts);

        this.available = {
            type: 'EC2',
            name: 'test service',
            count: 2,
            size: 100,
            port: 0,
            alb: true
        };

        this.output = {
            name: '',
            size: 100
        }
    }


    prompting() {
        return this.prompt([{
            type: 'input',
            name: 'name',
            message: 'What is the name of your ' + this.available.type + ' instance ?',
            default: this.available.name
        }, {
            type: 'input',
            name: 'count',
            message: 'How many ' + this.available.type + 's would you like ? ',
            default: this.available.count
        }, {
            type: 'confirm',
            name: 'alb',
            message: 'Would you like to add a load balancer ?',
            default: this.available.alb
        }, {
            type: 'input',
            name: 'port',
            message: 'What additional port would you like to open ?',
            default: this.available.port
        }
        ]).then((answers) => {
            this.output.type = this.available.type;
            this.output.name = answers.name.replace(/ /g, "_"); //Replace empty space with _
            this.output.count = answers.count;
            this.output.alb = answers.alb;
            this.output.port = answers.port;

            this.log('Type', this.output.type);
            this.log('Name', this.output.name);
            this.log('Count', this.output.count);
            this.log('ALB', this.output.alb);
            this.log('Port', this.output.port);
        });
    }

    writing() {
        this.fs.copyTpl(this.templatePath('modules/{name}_ec2.tf'), this.destinationPath(this.output.name + '/modules/' + this.output.name + '/' + this.output.name + '_ec2.tf'), this._private_getTpl());
        this.fs.copyTpl(this.templatePath('modules/{name}_sg.tf'), this.destinationPath(this.output.name + '/modules/' + this.output.name + '/' + this.output.name + '_sg.tf'), this._private_getTpl());
        this.fs.copyTpl(this.templatePath('modules/variables.tf'), this.destinationPath(this.output.name + '/modules/' + this.output.name + '/variables.tf'), this._private_getTpl());

        this.fs.copyTpl(this.templatePath('stage/{name}.tf'), this.destinationPath(this.output.name + '/stage/' + this.output.name + '.tf'), this._private_getTpl());
        this.fs.copyTpl(this.templatePath('stage/variables.tf'), this.destinationPath(this.output.name + '/stage/variables.tf'), this._private_getTpl());

        this.fs.copyTpl(this.templatePath('prod/{name}.tf'), this.destinationPath(this.output.name + '/prod/' + this.output.name + '.tf'), this._private_getTpl());
        this.fs.copyTpl(this.templatePath('prod/variables.tf'), this.destinationPath(this.output.name + '/prod/variables.tf'), this._private_getTpl());

        if (this.output.alb) {
            this.composeWith(require.resolve('../alb'), { name: this.output.name, port: this.output.port });
        }

        console.warn('Verify for duplicate ports in security group.');
        console.warn('Verify the ami.');
        
    }

    _private_getTpl() {
        return { NAME: this.output.name, SIZE: this.output.size, COUNT: this.output.count, PORT: this.output.port };
    }
}