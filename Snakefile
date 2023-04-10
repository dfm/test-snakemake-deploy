rule all:
    input:
        [f"{name}.txt" for name in ["a", "b"]]
    
rule write_file:
    output:
        "{name}.txt"
    conda:
        "workflow/envs/environment.yml"
    threads: 1
    resources:
        mem=30
    shell:
        """
        python --version > {output:q}
        """
