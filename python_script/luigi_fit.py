import luigi
import subprocess


class SingleFit(luigi.Task):

    filename = luigi.Parameter()
    tcl_script = luigi.Parameter()
    path_to_data = luigi.Parameter()
    path_to_rundir = luigi.Parameter()


    def output(self):
        return luigi.LocalTarget(self.filename+'.sh')


    def run(self):
        temp_sh = self.create_sh()
        self.launch_sh(temp_sh)

    def create_sh(self):

        cmdlist = ['xspec<<EOF',
                'source ' + self.tcl_script,
                'myfit ' + self.filename + ' ' + self.path_to_data + ' ' +self.path_to_rundir,
                'EOF']

        temp_sh = self.filename + '.sh'

        # Write the shell script
        f = open(temp_sh, 'w')
        for cmd in cmdlist:
          f.write(cmd + '\n')

        return temp_sh


    def launch_sh(self, temp_sh):
        subprocess.call(["bash", temp_sh])

    #def clean_up(self):
    #    subprocess.call(["bash", "rm *.sh"])

class LaunchAll(luigi.Task):

    obslist = set(line.strip() for line in open('testlist.dat'))
    tcl_script = 'modelspin_singlepcu_m2l.tcl'
    path_to_data = '/Users/charith/Documents/xrayspectralanalysis/data/grs1915/soft_steady/znsrun1_phacorr'
    path_to_rundir = '/Users/charith/Documents/xrayspectralanalysis/data/grs1915/spin_project/rundir'

    def requires(self):
        for obs in self.obslist:
            yield SingleFit(
                            filename=obs,
                            tcl_script=self.tcl_script,
                            path_to_data=self.path_to_data,
                            path_to_rundir=self.path_to_rundir
                            )


if __name__ == "__main__":
    luigi.run()
