# TaskServices Use Cases

Quick-start guides for common “app is suspending” scenarios using PlayMaker custom actions.

## Available Use Cases

### 1. [Basic Background Task](use-case-1-basic-background-task.md)
**What it does:** Start background allowance, save, then end the task.
**Actions:** 2 (`TaskServicesStartTaskAndAllowInBackground`, `TaskServicesCancelTask`)

---

### 2. [Quota Management](use-case-2-quota-management.md)
**What it does:** Handle quota expiry by switching to an emergency “save minimal” path.
**Actions:** 2 (`TaskServicesStartTaskAndAllowInBackground`, `TaskServicesCancelTask`)

---

### 3. [Upload Completion](use-case-3-upload-completion.md)
**What it does:** Try to finish a small upload; if time expires, save-for-retry.
**Actions:** 2 (`TaskServicesStartTaskAndAllowInBackground`, `TaskServicesCancelTask`)

---

## Choosing the Right Use Case

**Start Here:**
- Need to save data on suspend? → **Use Case 1** (Basic Background Task)
- Need to handle forced termination? → **Use Case 2** (Quota Management)
- Need to complete uploads? → **Use Case 3** (Upload Completion)

## Quick Action Reference

| Action | Purpose | Used In |
|--------|---------|---------|
| TaskServicesStartTaskAndAllowInBackground | Start background allowance | 1, 2, 3 |
| TaskServicesCancelTask | End the allowance | 1, 2, 3 |
| TaskServicesGetError | Read cached error after failure | Optional |

## Related Documentation

- **[README.md](../README.md)** - Complete actions list + platform limitations
