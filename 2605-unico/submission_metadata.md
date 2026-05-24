# Submission Metadata

## Title

```text
Towards a Universal Causal Reasoner
```

## Authors

```text
Qirun Dai, Xiao Liu, Jiawei Zhang, Dylan Zhang, Hao Peng, Chenhao Tan
```

## Affiliations

```text
Qirun Dai: The University of Chicago
Xiao Liu: The University of Chicago
Jiawei Zhang: The University of Chicago
Dylan Zhang: University of Illinois Urbana-Champaign
Hao Peng: University of Illinois Urbana-Champaign
Chenhao Tan: The University of Chicago
```

## Author Notes

```text
Qirun Dai, Xiao Liu, and Jiawei Zhang contributed equally.
Qirun Dai and Xiao Liu are project co-leads.
Correspondence to: qirundai@uchicago.edu, liuxiao@uchicago.edu, chenhao@uchicago.edu.
```

## Abstract

```text
Despite the importance of causal reasoning, training LLMs to reason causally remains underexplored. Existing data efforts mostly focus on benchmarking LLMs on specific aspects of causality, making them less suitable for training generalizable causal reasoners. To address this, we propose UniCo, a data generation framework that both (1) addresses 18 causal query types across Pearl's Causal Ladder and (2) translates natively symbolic examples into code and natural language forms to simulate real-world use cases where causal terms are not explicitly specified. To ensure data quality, UniCo grounds answers with exact causal inference and filters cases with reasoning shortcuts. Upon supervised finetuning with 66.6K UniCo-generated instances, Qwen3-4B, Qwen3-8B and Olmo-3-7B-Instruct achieve an average of 22.9% improvements across all 18 in-distribution query types, and 8.1% over state-of-the-art causal data generation frameworks on 7 established causal benchmarks outside the training distribution. More importantly, in real-world medical understanding, legal decision, and tabular reasoning, UniCo-trained models consistently display more faithful reasoning traces, outperforming the base models by an average of 20.2% in faithfulness metrics. These suggest that causality-centered training not only strengthens causal reasoning, but also equips LLMs with a causal mindset in general reasoning tasks.
```

## Dataset And Code Note

```text
All UniCo-generated datasets are available at https://huggingface.co/collections/ChicagoHAI/unico. Code will be soon available.
```
