# Submission Metadata

## Title

```text
Improving Influence-based Instruction Tuning Data Selection for Balanced Learning of Diverse Capabilities
```

## Authors

```text
Qirun Dai, Dylan Zhang, Jiaqi W. Ma, Hao Peng
```

## Affiliations

```text
Qirun Dai: University of Illinois Urbana-Champaign; The University of Chicago
Dylan Zhang: University of Illinois Urbana-Champaign
Jiaqi W. Ma: University of Illinois Urbana-Champaign
Hao Peng: University of Illinois Urbana-Champaign
```

## Author Notes

```text
Qirun Dai completed this work during an internship at the University of Illinois Urbana-Champaign.
```

## Abstract

```text
Selecting appropriate training data is crucial for instruction fine-tuning of large language models (LLMs), which aims to (1) elicit strong capabilities, and (2) achieve balanced performance across different tasks. Influence-based methods show promise in achieving (1), by estimating the contribution of each training example to the model's predictions, but often struggle with (2). Our systematic investigation reveals that this underperformance can be attributed to an inherent bias, where some tasks intrinsically have greater influence than others. As a result, data selection is often biased towards these tasks, not only hurting the model's performance on others but also, counterintuitively, harming performance on these high-influence tasks themselves. To address this, we propose BIDS, a Balanced and Influential Data Selection algorithm. BIDS first normalizes influence scores of the training data, and then iteratively chooses the training example with the highest influence on the most underrepresented task. Experiments with both Llama-3 and Mistral-v0.3 on seven benchmarks spanning five diverse capabilities show that BIDS consistently outperforms both state-of-the-art influence-based algorithms and other non-influence-based frameworks. Surprisingly, training on a 15% subset selected by BIDS can even outperform full-dataset training with a much more balanced performance. Our analysis highlights the importance of both instance-level normalization and iterative optimization of selected data for balanced learning of diverse capabilities.
```
