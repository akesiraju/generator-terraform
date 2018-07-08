var S3Generator = require('yeoman-generator');
module.exports = class extends S3Generator {
    // The name `constructor` is important here
    constructor(args, opts) {
        // Calling the super constructor is important so our generator is correctly set up
        super(args, opts);

        this.available = {
            type: 'S3',
            name: 'test bucket'
        };

        this.output = {
            name: ''
        }
    }


    prompting() {
        return this.prompt([{
            type: 'input',
            name: 'name',
            message: 'What is the name of the ' + this.available.type + ' bucket ?',
            default: this.available.name
        }
        ]).then((answers) => {
            this.output.type = this.available.type;
            this.output.name = answers.name.replace(/ /g, "_"); //Replace empty space with _

            this.log('Type', this.output.type);
            this.log('Name', this.output.name);
        });
    }

    writing() {
        this.fs.copyTpl(this.templatePath('stage/{name}_s3.tf'), this.destinationPath(this.output.name + '/stage/' + this.output.name + '_s3.tf'), this._private_getTpl());
        this.fs.copyTpl(this.templatePath('prod/{name}_s3.tf'), this.destinationPath(this.output.name + '/prod/' + this.output.name + '_s3.tf'), this._private_getTpl());
    }

    _private_getTpl() {
        return { NAME: this.output.name };
    }
}