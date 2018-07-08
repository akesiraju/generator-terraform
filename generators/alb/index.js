var ALBGenerator = require('yeoman-generator');
module.exports = class extends ALBGenerator {
    // The name `constructor` is important here
    constructor(args, opts) {
        // Calling the super constructor is important so our generator is correctly set up
        super(args, opts);

        this.argument('name', { type: String, required: false });
        this.argument('port', { type: Number, required: false });

        this.available = {
            type: 'ALB',
            name: this.options.name,
            port: this.options.port
        };

        this.output = {
            name: this.available.name,
            port: this.available.port
        }
    }


    prompting() {
        return this.prompt([{
            type: 'input',
            name: 'name',
            message: 'What is the name of your ' + this.available.type + '?',
            default: this.available.name,
            when: this.options.name == undefined
        }, {
            type: 'input',
            name: 'port',
            message: 'What port would you like to open ?',
            default: this.available.port,
            when: this.options.name == undefined
        }
        ]).then((answers) => {
            this.output.type = this.available.type;
            this.output.name = this.options.name == undefined ? answers.name.replace(/ /g, "_") : this.options.name.replace(/ /g, "_"); //Replace empty space with _   
            this.output.port = this.options.name == undefined ? answers.port : this.options.port;

            this.log('Type', this.output.type);
            this.log('Name', this.output.name);
            this.log('Port', this.output.port);
        });
    }

    writing() {
        this.fs.copyTpl(this.templatePath('modules/{name}_alb.tf'), this.destinationPath(this.output.name + '/modules/' + this.output.name + '/' + this.output.name + '_alb.tf'), this._private_getTpl());
        this.fs.copyTpl(this.templatePath('modules/{name}_alb_sg.tf'), this.destinationPath(this.output.name + '/modules/' + this.output.name + '/' + this.output.name + '_alb_sg.tf'), this._private_getTpl());

        console.warn('Verify for duplicate ports in security group.');
    }

    _private_getTpl() {
        return { NAME: this.output.name, PORT: this.output.port };
    }
}