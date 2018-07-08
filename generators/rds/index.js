var ALBGenerator = require('yeoman-generator');
module.exports = class extends ALBGenerator {
    // The name `constructor` is important here
    constructor(args, opts) {
        // Calling the super constructor is important so our generator is correctly set up
        super(args, opts);

        this.available = {
            type: 'RDS',
            name: 'test',
            engine: '',
            port: 0
        };

        this.output = {
            name: this.available.name,
            port: this.available.port,
            engine: this.available.engine
        }
    }


    prompting() {
        return this.prompt([{
            type: 'input',
            name: 'name',
            message: 'What is the name of your ' + this.available.type + ' database ?',
            default: this.available.name
        }, {
            type: 'input',
            name: 'port',
            message: 'What port would you like to open ?',
            default: this.available.port
        }, {
            type: 'list',
            name: 'engine',
            message: 'Select a sql engine.',
            choices: ['mysql', 'sqlserver-se', 'postgres']
        }
        ]).then((answers) => {
            this.output.type = this.available.type;
            this.output.name = answers.name.replace(/ /g, "_"); //Replace empty space with _   
            this.output.port = answers.port;
            this.output.engine = answers.engine;

            this.log('Type', this.output.type);
            this.log('Name', this.output.name);
            this.log('Port', this.output.port);
            this.log('Engine', this.output.engine);
        });
    }

    writing() {
        this.fs.copyTpl(this.templatePath('modules/{name}_rds.tf'), this.destinationPath(this.output.name + '/modules/' + this.output.name + '/' + this.output.name + '_rds.tf'), this._private_getTpl());
        this.fs.copyTpl(this.templatePath('modules/{name}_rds_sg.tf'), this.destinationPath(this.output.name + '/modules/' + this.output.name + '/' + this.output.name + '_rds_sg.tf'), this._private_getTpl());
        this.fs.copyTpl(this.templatePath('modules/variables.tf'), this.destinationPath(this.output.name + '/modules/' + this.output.name + '/variables.tf'), this._private_getTpl());

        this.fs.copyTpl(this.templatePath('stage/{name}.tf'), this.destinationPath(this.output.name + '/stage/' + this.output.name + '.tf'), this._private_getTpl());
        this.fs.copyTpl(this.templatePath('stage/variables.tf'), this.destinationPath(this.output.name + '/stage/variables.tf'), this._private_getTpl());

        this.fs.copyTpl(this.templatePath('prod/{name}.tf'), this.destinationPath(this.output.name + '/prod/' + this.output.name + '.tf'), this._private_getTpl());
        this.fs.copyTpl(this.templatePath('prod/variables.tf'), this.destinationPath(this.output.name + '/prod/variables.tf'), this._private_getTpl());

        console.warn('Verify the database engine version and port.');        
    }

    _private_getTpl() {
        return {
            NAME: this.output.name,
            PORT: this.output.port,
            ENGINE: this.output.engine
        };
    }
}