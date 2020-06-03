import gdb
import os

class SimpleCommand(gdb.Command):
    def __init__(self):
        # This registers our class as "simple_command"
        super(SimpleCommand, self).__init__("simple_command", gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        # When we call "simple_command" from gdb, this is the method
        # that will be called.
        print("Hello from simple_command!")

# This registers our class to the gdb runtime at "source" time.
SimpleCommand()

class ReloadSymbols(gdb.Command):
    def __init__(self):
        super(ReloadSymbols, self).__init__("reload_symbols", gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        regions = gdb.execute('info proc map', to_string=True).split('\n')
        mmap = {}
        for r in regions:
            cols = r.split()
            print('cols:', cols, 'len:', len(cols))
            if len(cols) > 4:
                if (not cols[4] in mmap and 
                        not "Start" in cols[0] and not "[" in cols[4] and 
                        not "/dev/zero" in cols[4] and 
                        os.path.exists(cols[4]) ):
                    print('region:', cols[0], cols[2], cols[4])
                    mmap[cols[4]] = cols[0]
                else:
                    print(cols[0], cols[4], "Already in map")
            else:
                if len(cols) > 0:
                    print(cols[0], "Too short") 
        for region in mmap:
            cmd = 'add-symbol-file ' + region + ' -o ' + mmap[region]
            gdb.execute('print "'+ cmd + '"')
            try:
                gdb.execute(cmd)
            except Exception:
                pass
ReloadSymbols()

