from snakemake.remote.GS import RemoteProvider as GSRemoteProvider

GS = GSRemoteProvider()

rule all:
    input:
        [GS.remote(f"test-bucket/{name}.txt") for name in ["a", "b"]]
    

rule write_file:
    output:
        GS.remote("test-bucket/{name}.txt")
    shell:
        """
        echo "Hello World" > {output:q}
        """
