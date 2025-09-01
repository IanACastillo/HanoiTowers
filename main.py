# main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from typing import List, Literal

app = FastAPI(title="Hanoi Solver API", version="1.0.0")

Rod = Literal["A", "B", "C"]

class SolveRequest(BaseModel):
    disks: int = Field(..., ge=1, le=12, description="Number of disks (1-12)")
    from_rod: Rod = Field("A", alias="from")
    to_rod: Rod = Field("C", alias="to")
    aux_rod: Rod = Field("B", alias="aux")

class Step(BaseModel):
    disk: int
    from_: Rod = Field(..., alias="from")
    to: Rod

class SolveResponse(BaseModel):
    disks: int
    count: int
    steps: List[Step]

@app.get("/health")
def health():
    return {"ok": True}

def hanoi(n: int, src: Rod, dst: Rod, aux: Rod, out: List[Step]) -> None:
    if n == 1:
        out.append(Step(disk=1, **{"from": src}, to=dst))
        return
    hanoi(n-1, src, aux, dst, out)
    out.append(Step(disk=n, **{"from": src}, to=dst))
    hanoi(n-1, aux, dst, src, out)

@app.post("/solve", response_model=SolveResponse)
def solve(req: SolveRequest):
    if len({req.from_rod, req.to_rod, req.aux_rod}) != 3:
        raise HTTPException(status_code=400, detail="Rods must be distinct A, B, C")
    steps: List[Step] = []
    hanoi(req.disks, req.from_rod, req.to_rod, req.aux_rod, steps)
    return SolveResponse(disks=req.disks, count=len(steps), steps=steps)
